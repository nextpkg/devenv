" Vundle's UI command does not propagate git failures to the process exit code.
try
    for s:bundle in g:vundle#bundles
        let s:result = vundle#installer#install(0, s:bundle.name)
        if s:result ==# 'error' || !isdirectory(s:bundle.path())
            throw 'Plugin installation failed: ' . s:bundle.name
        endif
    endfor
    if vundle#installer#helptags(g:vundle#bundles) > 0
        throw 'Plugin documentation generation failed'
    endif
catch
    echomsg v:exception
    cquit 1
endtry
qall!
