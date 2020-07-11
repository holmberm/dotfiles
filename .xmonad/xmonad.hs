import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Scratchpad
import XMonad.Actions.Submap
import System.IO
import System.Exit

import qualified Data.Map        as M
import qualified XMonad.StackSet as W

main = do
  xmproc <- spawnPipe "xmobar"
  xmonad $ docks defaultConfig
    { manageHook = manageDocks <+> scratchpadManageHookDefault <+> manageHook defaultConfig
    , layoutHook = avoidStruts $ layoutHook defaultConfig
    , logHook = dynamicLogWithPP xmobarPP
                { ppOutput = hPutStrLn xmproc
                , ppTitle = xmobarColor "green" "" . shorten 50
                }
    , modMask = mod4Mask -- Rebind Mod to the Command key
    , terminal = myTerminal
    -- Looks
    , normalBorderColor    = "black"
    , focusedBorderColor   = "green"
    , workspaces = myWorkspaces
    } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_z), spawn "urxvt")
        , ((controlMask, xK_Print), spawn "chrome")
        , ((0, xK_Escape), submap . M.fromList $
            [ ((0, xK_h     ), sendMessage Shrink)
            , ((0, xK_l     ), sendMessage Expand)
            -- utils
            , ((0, xK_s     ), scratchpadSpawnActionTerminal myTerminal)
            , ((0, xK_p     ), spawn "dmenu_run")
            -- Quit & Restart xmonad 
            , ((0 .|. shiftMask   , xK_q ), io (exitWith ExitSuccess)) 
            , ((0                 , xK_q ), broadcastMessage ReleaseResources >> restart "xmonad" True)
            ] ++
            -- Please excuse the syntax here... IDK why the fuck
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
          )
        ] -- end of submap


myWorkspaces = ["1:main", "2:code", "3:web"] ++ map show [4..7] ++ ["8:ssh", "9:music"]

myTerminal = "urxvt"
