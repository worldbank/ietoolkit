
  group code = the value this group have in the group variable in the date set
  group position  = the position number the



  **************************
  Things to test:

  * Check that tests across groups with special case variation behaves incorrectly
    * All obs in both groups has the same value. No variance within or across groups. Ex: gen balancevar = 1
    * All obs in one group has one value and all obs in the other another value. Variance across groups but not within. Ex: gen balancevar = (treat == 1)
    * One group has variance but the does not. Variance across group and within one group but not within the other. Ex: replace balancevar = 1 if treat == 1
    * The groups has the same number obs and exact pairs across the group exists. Variance within the group but no variance across the groups. Ex: bysort treat : gen balancevar = _n
