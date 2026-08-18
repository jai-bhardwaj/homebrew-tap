cask "k8secret" do
  version "0.6.10"
  sha256 "cf2b2f2f4e7ce13911796d52438a2db31881ea4d7567590c7abb03892e0193ca"

  url "https://github.com/jai-bhardwaj/k8secret/releases/download/v#{version}/K8Secret-#{version}.dmg"
  name "K8Secret"
  desc "Native client for Kubernetes secrets, deployments, pods and services"
  homepage "https://github.com/jai-bhardwaj/k8secret"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  # A bare symbol already means "this version or newer"; the string comparison
  # form is deprecated and warned on every brew command that touched this tap.
  depends_on macos: :sonoma

  app "K8Secret.app"

  # K8Secret is ad-hoc signed (personal project, no Apple Developer account).
  # Homebrew has already verified the DMG against the sha256 above, which is
  # published in the repo's release manifest alongside the code that built it.
  # Without this, Gatekeeper would refuse the first launch outright.
  #
  # must_succeed: false because this must never be able to fail an install.
  # `xattr -dr` exits non-zero when the path isn't there — a different --appdir,
  # an app the user moved — and a failed postflight aborts the whole install for
  # something entirely recoverable. Worst case without it is one Gatekeeper
  # prompt on first launch; worst case with it is no app at all.
  postflight do
    system_command "/usr/bin/xattr",
                   args:         ["-dr", "com.apple.quarantine", "#{appdir}/K8Secret.app"],
                   must_succeed: false
  end

  zap trash: [
    "~/Library/Preferences/com.sujalsharma.k8secret.plist",
    "~/Library/Saved Application State/com.sujalsharma.k8secret.savedState",
  ]

  caveats <<~EOS
    K8Secret is ad-hoc signed — integrity is verified by the sha256 in this
    cask, which matches release/latest.json in the main repo. The app updates
    itself (sha256-gated); `brew upgrade` will also work but isn't required.
  EOS
end
