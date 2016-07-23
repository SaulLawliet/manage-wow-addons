# Manage Wow AddOns
Install&amp;Update [World of Warcraft's](http://us.battle.net/wow/en/) AddOns from [Curse](http://mods.curse.com/addons/wow).

[NOTICE]: Only `bash` version. So maybe cannot run in Windows.

# Usage
1. Download or Clone, then enter

  ```
  $ git clone https://github.com/SaulLawliet/manage-wow-addons.git
  ...
  $ cd manage-wow-addons
  ```

1. Create or Edit data.txt

  ```
  ...
  $ cat data.txt
  bagnon
  master-plan
  npcscan
  ```

1. Run

  ```
  $ ./manage.sh [WoW dir]
  bagnon()
    -> check version...
    -> new: 7.0.3
    -> download...
    -> extract...
    -> DONE
  master-plan()
    -> check version...
    -> new: 0.97
    -> download...
    -> extract...
    -> DONE
  npcscan()
    -> check version...
    -> new: 7.0.3.4
    -> download...
    -> extract...
    -> DONE
  
  # Look
  $ tree [WoW dir]/Interface/AddOns/ -L 1
  [WoW dir]/Interface/AddOns
  ├── BagBrother
  ├── Bagnon
  ├── Bagnon_Config
  ├── Bagnon_GuildBank
  ├── Bagnon_VoidStorage
  ├── MasterPlan
  ├── MasterPlanA
  └── _NPCScan
  
  # Run Again
  $ ./manage.sh [WoW dir]
  bagnon(7.0.3)
    -> check version...
    -> new 7.0.3
    -> SKIP
  master-plan(0.97)
    -> check version...
    -> new 0.97
    -> SKIP
  npcscan(7.0.3.4)
    -> check version...
    -> new 7.0.3.4
    -> SKIP
    
  # Why?
  $ cat data.txt
  bagnon 7.0.3
  master-plan 0.97
  npcscan 7.0.3.4
  ```
  
