cask "k8secret" do
  version "0.5.9"
  sha256 "26b118dc16635eacefd55131501ab114debb0c64075f3f47f5e91e90d66c141b"

  url "https://github.com/jai-bhardwaj/k8secret/releases/download/v#{version}/K8Secret-#{version}.dmg"
  name "K8Secret"
  desc "Native macOS client for Kubernetes secrets, deployments, pods and services"
  homepage "https://github.com/jai-bhardwaj/k8secret"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :sonoma"

  app "K8Secret.app"

  # K8Secret is ad-hoc signed (personal project, no Apple Developer account).
  # Homebrew has already verified the DMG against the sha256 above, which is
  # published in the repo's release manifest alongside the code that built it.
  # Without this, Gatekeeper would refuse the first launch outright.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/K8Secret.app"]
  end

  caveats <<~EOS
    K8Secret is ad-hoc signed — integrity is verified by the sha256 in this
    cask, which matches release/latest.json in the main repo. The app updates
    itself (sha256-gated); `brew upgrade` will also work but isn't required.
  EOS

  zap trash: [
    "~/Library/Preferences/com.sujalsharma.k8secret.plist",
    "~/Library/Saved Application State/com.sujalsharma.k8secret.savedState",
  ]
end
