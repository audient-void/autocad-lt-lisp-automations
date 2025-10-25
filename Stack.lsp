;; Helper function to offset a point's Y coordinate
;; Handles both 2D (X Y) and 3D (X Y Z) points
(defun offset-y-coord (pt yoffset / z)
  (if pt
    (progn
      (setq z (if (>= (length pt) 3) (caddr pt) 0))  ; Get Z or default to 0
      (list (car pt) (+ (cadr pt) yoffset) z)
    )
    nil
  )
)

;; Helper function to offset entity Y coordinates
(defun offset-entity-y (ent yoffset / newent item newpt)
  (setq newent '())
  (foreach item ent
    (cond
      ;; For coordinates (codes 10, 11, etc.) - offset Y value
      ;; Handle both 2D points (LWPOLYLINE) and 3D points (LINE)
      ((and (= (type (cdr item)) 'LIST)
            (or (= (length (cdr item)) 2) (= (length (cdr item)) 3))
            (or (= (car item) 10) (= (car item) 11)))
       (setq newpt (offset-y-coord (cdr item) yoffset))
       (setq newent (append newent (list (cons (car item) newpt))))
      )
      ;; Skip handle and entity name (codes -1, -2, 5, 102, 330)
      ((or (= (car item) -1) (= (car item) -2) (= (car item) 5)
           (= (car item) 102) (= (car item) 330))
       nil
      )
      ;; Keep everything else as is
      (t
       (setq newent (append newent (list item)))
      )
    )
  )
  newent
)

(defun c:Stack ( / obj ent objtype height numcopies idx yoffset newent)

  ;; Prompt user to select a line or polyline
  (setq obj (car (entsel "\nSelect line or polyline to stack: ")))

  (if obj
    (progn
      (setq ent (entget obj))
      (setq objtype (cdr (assoc 0 ent)))

      (if (or (= objtype "LINE") (= objtype "LWPOLYLINE"))
        (progn
          ;; Prompt for floor-to-floor height
          (initget 7)  ; Prevents zero, negative, and null input
          (setq height (getdist "\nEnter floor-to-floor height: "))

          ;; Prompt for number of copies
          (initget 7)  ; Prevents zero, negative, and null input
          (setq numcopies (getint "\nEnter number of copies to create: "))

          ;; Create copies stacked on Y axis
          (setq idx 1)
          (repeat numcopies
            ;; Calculate Y offset for this copy
            (setq yoffset (* idx height))

            ;; Create new entity with Y offset
            (setq newent (offset-entity-y ent yoffset))
            (entmake newent)

            (setq idx (1+ idx))
          )

          (princ (strcat "\n" (itoa numcopies) " object(s) stacked successfully."))
        )
        (princ "\nError: Selected object is not a line or polyline. Please select a LINE or LWPOLYLINE object.")
      )
    )
    (princ "\nNo object selected.")
  )
  (princ)
)
