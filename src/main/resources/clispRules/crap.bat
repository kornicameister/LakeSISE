
        (defrule createTokenLogic
            (declare (salience 4444))
            =>
            (assert (token (activated 0) (who "")))
            (printout t "Created token" crlf)
        )
        (defrule passTokenToActor_Init
            (declare (salience 2222))
            ?token  <-  (token (activated 0) (who ""))
            ?actor  <-  (actor (id ?a-id) (hasToken no) (actionDone no) (isMoveChanged yes))
            =>
            (modify ?token  (activated 1) (who ?a-id))
            (modify ?actor (hasToken ?*true*))
            (printout t "Passing token to the first actor " ?a-id crlf)
        )
        (defrule passTokenToActor
            (declare (salience ?*HIGH-PRIORITY*))
            ?token  <-  (token (activated ?t-activated) (who ?a-id))
            ?actor  <-  (actor (id ?a-id) (hasToken yes) (actionDone yes))
            =>
            (modify ?actor  (hasToken ?*false*))
            (do-for-fact
                ((?ant actor))
                (and
                    (neq ?ant:id ?a-id)
                    (eq ?ant:hasToken no)
                    (eq ?ant:actionDone no)
                )
                (modify ?token  (activated (+ ?t-activated 1)) (who ?ant:id))
                (modify ?ant (hasToken ?*true*))
                (printout t "Token goes from " ?a-id " to " ?ant:id crlf)
            )
        )