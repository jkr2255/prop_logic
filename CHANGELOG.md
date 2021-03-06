# Ver. 0.2.4 (2016/04/09)
- Using Scrutinizer for code quality
- Performance improvements

# Ver. 0.2.3 (2016/04/06)
- Inprove performance in negating variables
- Optionally select normal Hash for caching

# Ver. 0.2.2 (2016/04/04)
- Improve performance in `AndTerm`/`OrTerm` generation

# Ver. 0.2.1 (2016/04/02)
- Improve performance in `#each_sat`

# Ver. 0.2.0 (2016/03/13)
- Add interface for incremental solver
- add `Term#each_sat`

# Ver. 0.1.3 (2016/03/11)
- Code cleanup
- save `PropLogic.sat_solver` to module instance variable (no interface change)

# Ver. 0.1.2 (2016/03/07)
- Cache @variables (avoid recursive search)

# Ver. 0.1.1 (2016/01/28)
- `PropLogic.all_and`/`PropLogic.all_or` with less than one argument(s) behaviors fixed
- And/or terms with duplicated subterms are no longer regarded as reduced

# Ver. 0.1.0 (2016/01/27)
Initial version
