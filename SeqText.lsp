(defun c:SeqText ( / ss num idx ent ename oldstr newstr)
  (setq ss (ssget '((0 . "TEXT,MTEXT")))) ; Select only TEXT and MTEXT
  (if ss
    (progn
      (initget 7)
      (setq num (getint "\nEnter starting number: "))
      (setq idx 0)
      (repeat (sslength ss)
        (setq ename (ssname ss idx))
        (setq ent (entget ename))
        (setq oldstr (cdr (assoc 1 ent))) ; Get current text string
        (setq newstr (strcat "{\\B" (itoa num) "\\B} " oldstr)) ; Prefix number with a period and space
        (setq ent (subst (cons 1 newstr) (assoc 1 ent) ent)) ; Replace text
        (entmod ent)
        (entupd ename)
        (setq idx (1+ idx))
        (setq num (1+ num))
      )
      (princ "\nText fields updated with sequential number prefixes.")
    )
    (prompt "\nNo text objects selected.")
  )
  (princ)
)
