;Forester is an actor who hunts down poacher and checks anglers

(defrule check-valid-id
	"rule to check if actor's in range of forester is angler/poacher and has validId"
	?nf		<-	(actorNeighbour (actor ?a-id) (neighbour ?n-id) (field ?f-id))
	?af 	<-	(actor (id ?a-id))
	?anf 	<-	(actor (id ?n-id))
	=>
	(retract ?nf)
	(printout t ?a-id " has neighbour " ?n-id " on field " ?f-id "." crlf)
)