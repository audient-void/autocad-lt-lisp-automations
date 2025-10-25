(defun c:CopyBlockAcrossSheets ( / blk blkent blkname inspt xscale yscale zscale rot
                                  layoutlist layoutname currentlayout
                                  copiedcount rotdeg ss)

  ;; Check for pre-selected block first, otherwise prompt user
  (setq ss (ssget "_I" '((0 . "INSERT"))))  ; Get implied selection (pre-selected)
  (if ss
    (setq blk (ssname ss 0))  ; Use first entity from pre-selection
    (setq blk (car (entsel "\nSelect block to copy: ")))  ; Prompt for selection
  )

  (if (and blk (= (cdr (assoc 0 (entget blk))) "INSERT"))
    (progn
      ;; Get block properties
      (setq blkent (entget blk))
      (setq blkname (cdr (assoc 2 blkent)))      ; Block name
      (setq inspt (cdr (assoc 10 blkent)))       ; Insertion point (X Y Z)
      (setq xscale (cdr (assoc 41 blkent)))      ; X scale factor
      (setq yscale (cdr (assoc 42 blkent)))      ; Y scale factor
      (setq zscale (cdr (assoc 43 blkent)))      ; Z scale factor
      (setq rot (cdr (assoc 50 blkent)))         ; Rotation angle in radians

      ;; Convert rotation to degrees for INSERT command
      (if rot
        (setq rotdeg (* rot (/ 180.0 pi)))
        (setq rotdeg 0)
      )

      ;; Get current layout
      (setq currentlayout (getvar "CTAB"))

      ;; Initialize counter
      (setq copiedcount 0)

      ;; Get list of all layouts using VLA functions
      (setq layoutlist '())
      (vlax-for layout (vla-get-layouts (vla-get-activedocument (vlax-get-acad-object)))
        (setq layoutlist (cons (vla-get-name layout) layoutlist))
      )

      ;; Process each layout
      (foreach layoutname layoutlist
        ;; Skip Model space and current layout
        (if (and layoutname
                 (/= (strcase layoutname) "MODEL")
                 (/= (strcase layoutname) (strcase currentlayout)))
          (progn
            ;; Switch to the layout
            (setvar "CTAB" layoutname)

            ;; Insert block at same position with same properties
            (command "_.INSERT"
                     blkname
                     inspt
                     xscale
                     yscale
                     rotdeg
            )

            (setq copiedcount (1+ copiedcount))
            (princ (strcat "\nCopied to layout: " layoutname))
          )
        )
      )

      ;; Return to original layout
      (setvar "CTAB" currentlayout)

      ;; Report results
      (if (> copiedcount 0)
        (princ (strcat "\n" (itoa copiedcount) " copy(ies) created successfully."))
        (princ "\nNo additional layouts found to copy to.")
      )
    )
    (princ "\nError: Selected object is not a block. Please select a block reference.")
  )
  (princ)
)
