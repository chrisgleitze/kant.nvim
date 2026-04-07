" kant.nvim — Immanuel Kants Quelltexte in Vim/Neovim durchsuchen
" Maintainer: Christian Gleitze

if exists('g:loaded_kant')
  finish
endif
let g:loaded_kant = 1

command! -nargs=? KantSearch lua require('kant.search').search(<q-args> ~= '' and <q-args> or nil)
command! -nargs=0 KantWerke lua require('kant.picker').werke()
command! -nargs=0 KantZufall lua require('kant.picker').zufall()
