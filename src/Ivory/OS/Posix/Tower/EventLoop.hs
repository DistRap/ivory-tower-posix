{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeOperators #-}

module Ivory.OS.Posix.Tower.EventLoop where

import Ivory.Language

ev_header :: String
ev_header = "ev.h"

[ivory|
abstract struct ev_loop "ev.h"
abstract struct ev_timer "ev.h"
abstract struct ev_io "ev.h"
|]

ev_READ, ev_WRITE, ev_TIMER, ev_ERROR :: Uint32
ev_READ = extern "EV_READ"
ev_WRITE = extern "EV_WRITE"
ev_TIMER = extern "EV_TIMER"
ev_ERROR = extern "EV_ERROR"

ev_default_loop :: Def ('[Uint32] :-> Ref s (Struct "ev_loop"))
ev_default_loop = importProc "ev_default_loop" ev_header

ev_now :: Def ('[Ref s (Struct "ev_loop")] :-> IDouble)
ev_now = importProc "ev_now" ev_header

ev_run :: Def ('[Ref s (Struct "ev_loop"), Sint32] :-> IBool)
ev_run = importProc "ev_run" ev_header

type CallbackPtr s2 s3 watcher = ProcPtr ('[Ref s2 (Struct "ev_loop"), Ref s3 (Struct watcher), Uint32] :-> ())

ev_timer_init :: Def ('[Ref s1 (Struct "ev_timer"), CallbackPtr s2 s3 "ev_timer", IDouble, IDouble] :-> ())
ev_timer_init = importProc "ev_timer_init" ev_header

ev_timer_start :: Def ('[Ref s1 (Struct "ev_loop"), Ref s2 (Struct "ev_timer")] :-> ())
ev_timer_start = importProc "ev_timer_start" ev_header

ev_io_init :: Def ('[Ref s1 (Struct "ev_io"), CallbackPtr s2 s3 "ev_io", Sint32, Uint32] :-> ())
ev_io_init = importProc "ev_io_init" ev_header

ev_io_start :: Def ('[Ref s1 (Struct "ev_loop"), Ref s2 (Struct "ev_io")] :-> ())
ev_io_start = importProc "ev_io_start" ev_header

uses_libev :: ModuleDef
uses_libev = do
  incl ev_default_loop
  incl ev_now
  incl ev_run
  incl ev_timer_init
  incl ev_timer_start
  incl ev_io_init
  incl ev_io_start