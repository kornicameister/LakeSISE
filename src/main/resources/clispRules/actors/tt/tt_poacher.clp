(deftemplate tt_poacher_bribe
   	(slot poacher
   		(type STRING))
   	(slot forester
   	    (type STRING))
   	(slot bribe
   		(type INTEGER))
)

(defrule tt_poacher_do_bribe
    ?ttpb       <-  (tt_poacher_bribe (poacher ?p-id) (forester ?f-id) (bribe ?b))
    ?forester   <-  (actor (id ?f-id) (type forester) (cash ?f-cash))
    ?poacher    <-  (actor (id ?p-id) (type poacher) (cash ?p-cash))
    =>
    (retract ?ttpb)
    (modify ?forester (cash (+ ?f-cash ?b)))
    (modify ?poacher (cash (- ?p-cash ?b)))
    (printout t "TicketDo :: " ?b crlf)
)

(defrule tt_poacher_bribe_forester
    "rule applies if the forester is the one who approaches poacher"
	?nf			<-	(actorNeighbour (actor ?a-id) (neighbour ?p-id) (field ?f-id))
	?forester 	<-	(actor (id ?a-id) (cash ?a-cash) (corruptionThreshold ?a-ct) (type forester))
	?poacher	<-	(actor (id ?p-id) (cash ?p-cash) (type poacher) (validId ?valid-id))
	(test
	    (>= ?p-cash ?a-ct))
	(test
	    (> ?p-cash 0))
	=>
	(retract ?nf)
	(bind ?tmp (- ?p-cash ?a-ct))
	(if (> ?tmp 0)
	    then
	        (assert (tt_poacher_bribe (poacher ?p-id) (forester ?a-id) (bribe ?tmp)))
	)
)