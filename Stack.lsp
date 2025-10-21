(defun c:Stack ( / obj ent height numcopies idx
                 pt1 pt2 newpt1 newpt2 yoffset)

  ;; Prompt user to select a line
  (setq obj (car (entsel "\nSelect line to stack: ")))

  (if (and obj (= (cdr (assoc 0 (entget obj))) "LINE"))
    (progn
      ;; Get line properties
      (setq ent (entget obj))
      (setq pt1 (cdr (assoc 10 ent)))  ; Start point (X Y Z)
      (setq pt2 (cdr (assoc 11 ent)))  ; End point (X Y Z)

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

        ;; Calculate new points with Y offset
        (setq newpt1 (list (car pt1)           ; X stays same
                           (+ (cadr pt1) yoffset)  ; Y increases
                           (caddr pt1)))        ; Z stays same

        (setq newpt2 (list (car pt2)           ; X stays same
                           (+ (cadr pt2) yoffset)  ; Y increases
                           (caddr pt2)))        ; Z stays same

        ;; Create new line
        (entmake
          (list
            (cons 0 "LINE")
            (cons 10 newpt1)
            (cons 11 newpt2)
            (cons 8 (cdr (assoc 8 ent)))  ; Same layer
          )
        )

        (setq idx (1+ idx))
      )

      (princ (strcat "\n" (itoa numcopies) " line(s) stacked successfully."))
    )
    (princ "\nError: Selected object is not a line. Please select a LINE object.")
  )
  (princ)
)
