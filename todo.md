##Todo for ieimpgraph
###Input testing
- [ ] Test that there is a regression result in memory
- Test dummies
  - [ ] Test basic case. Any number of dummies. No obs has value 1 in more than one dummy. Some obs (controls) has 0 in all dummies.
  - [ ] Test diff-diff. Exactly three dummies. One of the dummies is a product of the other two. There is at least one (or some) observations in each combination of the dummies

###Graph Stats Display
- Confidence interval
  - [X] Remove all
  - [X] Remove for specific treatments

###Graph Formatting
- Y-axis
  - [ ] Decide where the y-axis start. 0 or something else. If something else, test that all bars and conf.int. bars are inside that range
  - [ ] Dynamically set the ticks on the Y axis
  - [ ] Manually set the title of the Y axis
- Legend
  - [ ] Allow the user to set the labels in the legends
- [ ] Test that "anything" works when passing any graph two-way options to our command
- Check out cibar and other commands for formatting inspiration
  - [ ] cibar
  
  
###Output graph
- [x] manually set where to save to disk
- [ ] manually name the graph (i.e. save in working memory)
