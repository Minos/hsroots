module Graphics.Wayland.WlRoots.LinuxDMABuf
    ( LinuxDMABuf (..)
    , createDMABuf
    , destroyDMABuf
    )
where

import Foreign.Ptr (Ptr)
import Foreign.C.Error (throwErrnoIfNull)

import Graphics.Wayland.Server (DisplayServer(..))

import Graphics.Wayland.WlRoots.Egl (EGL)
import Graphics.Wayland.WlRoots.Backend (Backend, backendGetEgl)

newtype LinuxDMABuf = LinuxDMABuf (Ptr LinuxDMABuf)

foreign import ccall unsafe "wlr_linux_dmabuf_create" c_create :: Ptr DisplayServer -> Ptr EGL -> IO (Ptr LinuxDMABuf)

createDMABuf :: DisplayServer -> Ptr Backend -> IO LinuxDMABuf
createDMABuf (DisplayServer dsp) backend =
    LinuxDMABuf <$> throwErrnoIfNull "creatELinuxDMABuf" (c_create dsp =<< backendGetEgl backend)

foreign import ccall "wlr_linux_dmabuf_destroy" c_destroy :: Ptr LinuxDMABuf -> IO ()

destroyDMABuf :: LinuxDMABuf -> IO ()
destroyDMABuf (LinuxDMABuf ptr) = c_destroy ptr
