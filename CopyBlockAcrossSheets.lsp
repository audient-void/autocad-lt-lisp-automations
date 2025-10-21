(defun c:CopyBlockAcrossSheets ( / blk blkent blkname inspt xscale yscale zscale rot
                                  layoutdict layoutlist layoutname currentlayout
                                  copiedcount rotdeg)

  ;; Prompt user to select a block
  (setq blk (car (entsel "\nSelect block to copy: ")))

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

      ;; Get layouts dictionary
      (setq layoutdict (namedobjdict))
      (setq layoutdict (dictsearch layoutdict "ACAD_LAYOUT"))

      ;; Build list of layout names
      (setq layoutlist '())
      (if layoutdict
        (progn
          (setq layoutdict (cdr (assoc -1 layoutdict)))
          (while (setq layoutname (dichnext layoutdict (null layoutlist)))
            (if (setq layoutname (cdr (assoc 3 (dictsearch layoutdict (cdr (assoc 2 layoutname))))))
              (setq layoutlist (cons layoutname layoutlist))
            )
          )
        )
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
