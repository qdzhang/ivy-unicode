;;; ivy-unicode.el --- Ivy command for unicode characters. -*- lexical-binding: t -*-

;; Copyright © 2015 Emanuel Evans

;; Version: 0.0.4
;; Package-Requires: ((ivy) (emacs "24.4"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;; A ivy command for looking up unicode characters by name 😉.

;;; Code:

(require 'ivy)

(defvar ivy-unicode-names nil
  "Internal cache variable for unicode characters.  Should not be changed by the user.")

(defun ivy-unicode-format-char-pair (char-pair)
  "Formats a char pair for ivy unicode search."
  (let ((name (car char-pair))
        (symbol (cdr char-pair)))
    (format "%s %c" name symbol)))

(defun ivy-unicode-build-candidates ()
  "Builds the candidate list."
  (let ((unames (if (hash-table-p (ucs-names))
                    (mapcar (lambda (elem) `(,elem . ,(gethash elem (ucs-names)))) (hash-table-keys (ucs-names)))
                  (ucs-names))))
    (sort
     (mapcar 'ivy-unicode-format-char-pair unames)
     #'string-lessp)))

(defun ivy-unicode-insert-char (candidate)
  "Insert CANDIDATE into the main buffer."
  (insert (substring candidate -1)))

;;;###autoload
(defun ivy-unicode (arg)
  "Precofigured `ivy' for looking up unicode characters by name.

With prefix ARG, reinitialize the cache."
  (interactive "P")
  (when arg (setq ivy-unicode-names nil))
  (ivy-read "Unicode-char: " (ivy-unicode-build-candidates)
            :action (lambda (x) (ivy-unicode-insert-char x)))
  )

(provide 'ivy-unicode)

;;; ivy-unicode.el ends here
