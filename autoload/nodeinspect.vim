

let s:has_supported_python = 0
if has('python3')
    let s:has_supported_python = 2
elseif has('python')"
    let s:has_supported_python = 1
endif

if !s:has_supported_python
    function! s:NodeInspectDidNotLoad()
        echohl WarningMsg|echomsg "Node Inspect requires Vim to be compiled with Python 2.4+"|echohl None
    endfunction
    call s:NodeInspectDidNotLoad()
    finish
endif

let s:plugin_path = escape(expand('<sfile>:p:h'), '\')


function! s:NodeInspectToggleBreakpoint()
	if s:has_supported_python == 2
		python3 NodeInspectToggleBreakpoint()
	else
		python NodeInspectToggleBreakpoint()
	endif
endfunction

function! s:NodeInspectStepOver()
	if s:has_supported_python == 2
		python3 NodeInspectStepOver()
	else
		python NodeInspectStepOver()
	endif
endfunction

function! s:NodeInspectStepInto()
	if s:has_supported_python == 2
		python3 NodeInspectStepInto()
	else
		python NodeInspectStepInto()
	endif
endfunction

function! s:StartNodeInspect()
	" load the python module, if not already loaded
	if !exists('g:nodeinspect_py_loaded')
		if s:has_supported_python == 2
			exe 'py3file ' . escape(s:plugin_path, ' ') . '/nodeinspect.py'
			python3 initPythonModule()
		else
			exe 'pyfile ' . escape(s:plugin_path, ' ') . '/nodeinspect.py'
			python initPythonModule()
		endif

		if !s:has_supported_python
			function! s:NodeInspectDidNotLoad()
					echohl WarningMsg|echomsg "NodeInspect unavailable: requires Vim 7.3+"|echohl None
			endfunction
			call s:NodeInspectDidNotLoad()
			return
		endif"
		let g:nodeinspect_py_loaded = 1
	endif

	" start
	if s:has_supported_python == 2
		python3 StartNodeInspect()
	else
		python StartNodeInspect()
	endif
endfunction

function! OnNodeInspectExit(a,b,c)
	if s:has_supported_python == 2
		python3 NodeInspectCleanup()
	else
		python NodeInspectCleanup()
	endif
endfunction

function! NodeInspectTimerCallback(timer)
	if s:has_supported_python == 2
		python3 NodeInspectExecLoop()
	else
		python NodeInspectExecLoop()
	endif
endfunction

function! nodeinspect#NodeInspectToggleBreakpoint()
	if !exists('g:nodeinspect_py_loaded')
		echo "node-inspect not started"
		return
	endif
	call s:NodeInspectToggleBreakpoint()
endfunction

function! nodeinspect#NodeInspectStepOver()
	if !exists('g:nodeinspect_py_loaded')
		echo "node-inspect not started"
		return
	endif
	call s:NodeInspectStepOver()
endfunction

function! nodeinspect#NodeInspectStepInto()
	if !exists('g:nodeinspect_py_loaded')
		echo "node-inspect not started"
		return
	endif
	call s:NodeInspectStepInto()
endfunction


function! nodeinspect#StartNodeInspect()
    call s:StartNodeInspect()
endfunction
