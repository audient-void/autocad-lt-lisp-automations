(defun c:SeqTextReplace ( / ss num idx ent ename newstr)
  (setq ss (ssget '((0 . "TEXT,MTEXT")))) ; Select only TEXT and MTEXT
  (if ss
    (progn
      (initget 7)
      (setq num (getint "\nEnter starting number: "))
      (setq idx 0)
      (repeat (sslength ss)
        (setq ename (ssname ss idx))
        (setq ent (entget ename))
        (setq newstr (itoa num)) ; Replace with just the number
        (setq ent (subst (cons 1 newstr) (assoc 1 ent) ent)) ; Replace text
        (entmod ent)
        (entupd ename)
        (setq idx (1+ idx))
        (setq num (1+ num))
      )
      (princ "\nText fields replaced with sequential numbers.")
    )
    (prompt "\nNo text objects selected.")
  )
  (princ)
)
