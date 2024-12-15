---------------------------
-- spike's xmonad config --
---------------------------

import XMonad
import Data.Monoid
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

import XMonad.Hooks.ManageDocks

import XMonad.Layout.NoBorders (noBorders)
import XMonad.Layout.ResizableTile

import XMonad.Actions.Navigation2D

import XMonad.Util.SpawnOnce
import XMonad.Util.Run

import Graphics.X11.ExtraTypes.XF86

help :: String
help = unlines [
    "The modifier key is 'Super'. Keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch xterminal",
    "mod-p            Launch dmenu",
    "mod-Shift-p      Launch gmrun",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]


myTerminal      = "wezterm"
myFont          = "xft:JetBrainsNerdFont Mono"
myTextEditor    = "nvim"

myModMask       = mod4Mask -- Modifer key. mod4Mask is Super
myBorderWidth   = 2 -- Width of the window border in pixels.

-- Workspace counts and names
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

-- Border colors for unfocused and focused windows, respectively.
myNormalBorderColor  = "#000000"
myFocusedBorderColor = "#777777"

-- Mouse options
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Key bindings.
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    [ ((modm,               xK_Return), windows W.swapMaster)    -- Swap focused window and master window
    , ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf) -- launch terminal
    , ((modm,               xK_space ), spawn "dmenu_run")      -- launch dmenu
    , ((modm .|. shiftMask, xK_space ), spawn "gmrun")         -- launch gmrun
    , ((modm .|. shiftMask, xK_q     ), kill)                  -- close focused window

    -- Layout
    , ((modm,               xK_y), sendMessage NextLayout) -- rotate layouts
    , ((modm .|. shiftMask, xK_y), setLayout $ XMonad.layoutHook conf) -- reset layout
    , ((modm,               xK_n), refresh)               -- resize to correct size
    , ((modm,               xK_t), withFocused $ windows . W.sink) -- push window into tiling

    -- Focus
    , ((modm,               xK_Tab   ), windows W.focusDown)   -- focus next window
    , ((modm,               xK_h     ), windowGo L False)   -- focus left
    , ((modm,               xK_l     ), windowGo R False)   -- focus right
    , ((modm,               xK_k     ), windowGo U False)   -- focus up
    , ((modm,               xK_j     ), windowGo D False)   -- focus down
    , ((modm,               xK_m     ), windows W.focusMaster) -- focus master window

    -- Swap windows (with Ctrl)
    , ((modm .|. controlMask, xK_h     ), windowSwap L False)   -- swap left
    , ((modm .|. controlMask, xK_l     ), windowSwap R False)   -- swap right
    , ((modm .|. controlMask, xK_k     ), windowSwap U False)   -- swap up
    , ((modm .|. controlMask, xK_j     ), windowSwap D False)   -- swap down

    -- Resize (with Shift)
    , ((modm .|. shiftMask, xK_h     ), sendMessage Shrink)               -- shrink from right
    , ((modm .|. shiftMask, xK_l     ), sendMessage Expand)               -- expand to right
    , ((modm .|. shiftMask, xK_k     ), sendMessage MirrorShrink)         -- shrink from bottom
    , ((modm .|. shiftMask, xK_j     ), sendMessage MirrorExpand)         -- expand to bottom
    , ((modm,               xK_comma ), sendMessage (IncMasterN 1))    -- increment master
    , ((modm,               xK_period), sendMessage (IncMasterN (-1))) -- decrement master

    -- System
    , ((modm .|. shiftMask, xK_Escape    ), io (exitWith ExitSuccess))  -- quit
    , ((modm,               xK_Escape     ), spawn "killall xmobar; xmonad --recompile; xmonad --restart") -- restart
    , ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -")) -- show help

    -- Screenshot
    , ((0, xK_Print ), spawn "maim -s | xclip -selection clipboard -t image/png") -- select screenshot to clipboard
    , ((modm, xK_Print ), spawn "maim -s ~/Pictures/$(date +%s).png")-- select screenshot to file
    , ((0 .|. shiftMask,xK_Print ), spawn "maim | xclip -selection clipboard -t image/png")-- full to clipboard
    , ((modm .|. shiftMask, xK_Print ), spawn "maim ~/Pictures/$(date +%s).png")-- full screenshot to file

    -- Volume controls
    , ((0, xF86XK_AudioRaiseVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
    , ((0, xF86XK_AudioLowerVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")
    , ((0, xF86XK_AudioMute), spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")


    ]
    -- Workspaces
    ++ [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    -- Screens
    ++ [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Layouts:
myLayout = avoidStruts (tiled ||| noBorders Full)
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled = Tall nmaster delta ratio
    -- The default number of windows in the master pane
    nmaster = 1
    -- Default proportion of screen occupied by master pane
    ratio = 1/2
    -- Percent of screen to increment by when resizing panes
    delta = 5/100

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster)) -- mod-button1, Set the window to floating mode and move by dragging
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster)) -- mod-button2, Raise the window to the top of the stack
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster)) -- mod-button3, Set the window to floating mode and resize by dragging
    ]

------------------------------------------------------------------------
-- Window rules:
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

------------------------------------------------------------------------
-- Event handling
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging
myLogHook = return ()

------------------------------------------------------------------------
-- Startup hook
myStartupHook = do
    spawnOnce "nitrogen --restore &"
    spawnOnce "compton &"
    spawnOnce "eval $(ssh-agent)"

------------------------------------------------------------------------
main = do 
  xmproc <- spawnPipe "xmobar -x 0 ~/.config/xmobar/xmobar.config"
  xmonad $ docks defaults

defaults = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

        keys               = myKeys,
        mouseBindings      = myMouseBindings,

        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }
