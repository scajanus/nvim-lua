;; extends
(call
  function: (identifier) @_re_path
  arguments: (argument_list . (string
                              (string_content) @injection.content))
  (#eq? @_re_path "re_path")
  (#set! injection.language "regex"))

(call
  function: (identifier) @_re_path
  arguments: (argument_list . (binary_operator (string (string_content) @injection.content)))
  (#eq? @_re_path "re_path")
  (#set! injection.language "regex"))

(call
  function: (identifier) @_re_path
  arguments: (argument_list . (binary_operator (binary_operator (string (string_content) @injection.content))))
  (#eq? @_re_path "re_path")
  (#set! injection.language "regex"))
