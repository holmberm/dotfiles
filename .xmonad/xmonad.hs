import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Actions.CycleWS
import XMonad.Actions.Submap
import XMonad.Layout.NoBorders -- testing at 121031
import XMonad.Util.Dmenu
import XMonad.Util.Run
import XMonad.Util.Loggers
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Scratchpad --(scratchpadSpawnAction, scratchpadManageHookDefault)
import System.Exit
import System.IO

import qualified XMonad.StackSet as W
import qualified Data.Map        as M


----------------------------------------------------------------------
 
main = do
  bar2 <- spawnPipe "conky -c ~/.conkyrc | dzen2 -ta r -h 12 -x 600 -bg black"
  statuspipe <- spawnPipe "dzen2 -bg black -fg white -ta l -h 12 -w 600"
  xmonad $ defaultConfig {
               terminal             = "terminology"
             , normalBorderColor    = "black"
             , focusedBorderColor   = "green"
             , focusFollowsMouse    = False
             , workspaces           = myWorkspaces
             , modMask              = myModMask
             , keys                 = myKeys
             , manageHook           = manageDocks <+> scratchpadManageHookDefault
                                      <+> myManageHook <+> manageHook defaultConfig
             , layoutHook           = avoidStruts  $ smartBorders $ layoutHook defaultConfig
             -- , layoutHook           = myLayoutHook
             , logHook              = dynamicLogWithPP $ defaultPP 
               { 
                 ppCurrent           = dzenColor "#FFFFFF" "blue"
               , ppOutput          = hPutStrLn statuspipe
               -- , ppVisible         = dzenColor "#8B80A8" ""
               , ppHidden          = dzenColor "#FFFFFF" ""
               -- , ppHiddenNoWindows = dzenColor "#4A4459" ""
               , ppLayout          = dzenColor "#6B6382" ""
               , ppSep             = "  "
               , ppWsSep           = " "
               , ppUrgent          = dzenColor "#0071FF" ""
               , ppTitle           = dzenColor "#AA9DCF" "". shorten 300 
                                     . dzenEscape
               , ppSort = fmap (.scratchpadFilterOutWorkspace) $ ppSort defaultPP
               }
             }

----------------------------------------------------------------------

myModMask = mod4Mask

-- try to make matlab plots/everything float
myManageHook = composeAll
               [ className =? "com-mathworks-util-PostVMInit"  --> doFloat
               , title =? "Eclipse Platform " --> doFloat
               ]

-- remove borders from fullscreen layouts... ehh...
-- myLayoutHook = noBorders( Full ) |||   $  layoutHook defaultConfig


myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
    -- A submap with unmodded escape as prefix.
    [ ((0, xK_Escape), submap . M.fromList $
       [ ((0, xK_h     ), sendMessage Shrink)
       , ((0, xK_l     ), sendMessage Expand)
       -- bring up scratchpad
       , ((0, xK_s     ), scratchpadSpawnActionTerminal "xterm")
       -- launch dmenu
       , ((0, xK_p     ), spawn "dmenu_run")
       -- close focused window
       , ((0 .|. shiftMask, xK_c     ), kill)
       -- Move focus to the master window
       , ((0, xK_m     ), windows W.focusMaster  )
       -- Swap the focused window and the master window
       , ((0, xK_Return), windows W.swapMaster)
       -- Swap the focused window with the next window
       , ((0, xK_j     ), windows W.swapDown  )
       -- Swap the focused window with the previous window
       , ((0, xK_k     ), windows W.swapUp    )
       -- Push window back into tiling
       , ((0 .|. controlMask,  xK_t     ), withFocused $ windows . W.sink)
       -- Increment the number of windows in the master area
       , ((0, xK_comma ), sendMessage (IncMasterN 1))
       -- Deincrement the number of windows in the master area
       , ((0, xK_period), sendMessage (IncMasterN (-1)))
       -- launch a terminal
       , ((0 .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
       -- screenshot screen
       , ((0              , xK_Print), spawn "/usr/bin/screenshot scr")
       -- screenshot window or area
       , ((0 .|. shiftMask, xK_Print), spawn "/usr/bin/screenshot win")
       -- Quit xmonad 
       , ((0 .|. shiftMask   , xK_q ), io (exitWith ExitSuccess)) 
       -- Restart xmonad 
       , ((0                 , xK_q ), broadcastMessage ReleaseResources >> restart "xmonad" True)
       ---------------------------
       -- Sleep -- Not working  --
       ---------------------------
       --, ((0       , XF86Launch1 ), spawn "sudo /usr/sbin/hibernate-ram")
       ] ++
       -- this works but I don't understand it.
       -- [1..9], Switch to workspace N
       -- shift-[1..9], Move client to workspace N
       -- [((m .|. 0, k), windows $ f i)
       --  | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
       -- , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
       -- ]

       -- 1..9 switches to workspace
       [ ((0, k        ), windows $ W.greedyView i)
         | (i, k) <- zip myWorkspaces [xK_1 .. xK_9]
       ] ++
       -- shift+1..9 moves window to workspace
       [ ((shiftMask, k), (windows $ W.shift i))
         | (i, k) <- zip myWorkspaces [xK_1 .. xK_9]
       ] ++
       -- ctrl+1..9 moves window to workspace and switches to that workspace
       [ ((controlMask, k ), (windows $ W.shift i) >> (windows $ W.greedyView i))
         | (i, k) <- zip myWorkspaces [xK_1 .. xK_9]
       ]
      )        -- end of submap

    -- Rotate through the available layout algorithms
    , ((mod1Mask,               xK_space ), sendMessage NextLayout)
    --  Reset the layouts on the current workspace to default
    , ((mod1Mask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
    -- Move focus to the next window
    , ((mod1Mask,              xK_Tab   ), windows W.focusDown)
    -- Move focus to the previous window
    , ((mod1Mask .|. shiftMask, xK_Tab  ), windows W.focusUp  )

    -- sleep
    , ((0      ,                0x1008ff41), spawn "sudo /usr/sbin/hibernate-ram")
    -- Toggle touchpad
    , ((0,                      0x1008ffa9), spawn "/usr/bin/touchpad-toggle")
    -- Toggle VGA1
    , ((0, 0x1008ff59), spawn "/home/mattias/src/vgaToggler")
    ------ Cycle workspaces
    -- With DynamicWindows
    , ((modMask .|. controlMask, xK_period), nextWS)
    , ((modMask .|. controlMask,  xK_comma), prevWS)
    -- With RotView
    , ((modMask .|. controlMask,  xK_b), moveTo Next NonEmptyWS)
    , ((modMask .|. controlMask,   xK_n), moveTo Prev NonEmptyWS)
    -- Move window to next WS
    , ((modMask .|. shiftMask,    xK_b), shiftToNext)
    , ((modMask .|. shiftMask,     xK_n), shiftToPrev)

    -- Set screen brightness. err... deprecated...
    , ((0, xK_KP_End  ), spawn "sudo /home/mattias/script/br.sh 1")
    , ((0, xK_KP_Down ), spawn "sudo /home/mattias/script/br.sh 2")
    , ((0, xK_KP_Next ), spawn "sudo /home/mattias/script/br.sh 3")
    , ((0, xK_KP_Left ), spawn "sudo /home/mattias/script/br.sh 4")
    , ((0, xK_KP_Begin), spawn "sudo /home/mattias/script/br.sh 5")
    , ((0, xK_KP_Right), spawn "sudo /home/mattias/script/br.sh 6")
    , ((0, xK_KP_Home ), spawn "sudo /home/mattias/script/br.sh 7")
    , ((0, xK_KP_Up   ), spawn "sudo /home/mattias/script/br.sh 8")
    ]
    ++
 
    -- see to removing alt-shift-5 etc. Destroys emacs funct.
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N

    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) ([xK_1 .. xK_9] ++ [xK_0])
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]


-- Workspaces --
myWorkspaces = ["1:main", "2:code", "3:web"] ++ map show [4..7] ++ ["8:ssh", "9:music"]
