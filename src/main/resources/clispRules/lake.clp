(defglobal ?*lifeChange* = 5)

(deftemplate lake
    "Lake describes our environment - in status before iteration"
    (slot width)
    (slot length)
    (slot depth)
    (multislot actors)
    (slot weather))

(deftemplate lakeOut
    "Describes out status of the world, after each iteration"
    (multislot actors))
