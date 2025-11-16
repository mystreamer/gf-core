import Distribution.System (Platform(..), OS(..))
import Distribution.Simple (defaultMainWithHooks, UserHooks(..), simpleUserHooks)
import Distribution.Simple.LocalBuildInfo (LocalBuildInfo(..), hostPlatform)
import Distribution.Simple.Setup (BuildFlags(..), InstallFlags(..), CopyFlags(..))
import Distribution.PackageDescription (PackageDescription(..))
import System.FilePath ((</>), (<.>))

import WebSetup

main :: IO ()
main = defaultMainWithHooks simpleUserHooks
  { postBuild = gfPostBuild
  , postInst  = gfPostInst
  , postCopy  = gfPostCopy
  }
  where
    gfPostBuild args flags pkg lbi = do
      let gf = default_gf lbi
      buildWeb gf flags (pkg, lbi)

    gfPostInst args flags pkg lbi = do
      installWeb (pkg, lbi)

    gfPostCopy args flags pkg lbi = do
      copyWeb flags (pkg, lbi)

-- | Get path to locally-built gf executable
default_gf :: LocalBuildInfo -> FilePath
default_gf lbi = 
  "dist/build" </> "gf" </> ("gf" <.> exeExtension)
  where
    exeExtension = case hostPlatform lbi of
      Platform _ Windows -> "exe"
      _ -> ""
