# Formula for the tap icantcodefyi/homebrew-sakuralang (design §17.147). The version and
# SHA-256 placeholders are filled from the release's archives by `tools/release/release.py
# assemble`; the filled file is a release asset, reviewed before it goes to the tap as
# `Formula/sakuralang.rb`.
class SakuralangBeta < Formula
  desc "Agent-first programming language: the sakura compiler and toolchain"
  homepage "https://www.sakuralang.com"
  version "1.0.0-beta.2"
  license any_of: ["MIT", "Apache-2.0"]

  # `sakura run` and `sakura test` execute programs on Node; the release is qualified on Node 26.
  depends_on "node"

  on_macos do
    on_arm do
      url "https://github.com/icantcodefyi/sakuralang/releases/download/v1.0.0-beta.2/sakuralang-1.0.0-beta.2-aarch64-apple-darwin.tar.gz"
      sha256 "0495e488e39341c8f63daf39c05186ae878aea93b674407e66410b8d264005ee"
    end
    on_intel do
      url "https://github.com/icantcodefyi/sakuralang/releases/download/v1.0.0-beta.2/sakuralang-1.0.0-beta.2-x86_64-apple-darwin.tar.gz"
      sha256 "555e0dffe1c14f0c7b9b4c992df634d6566dce8e803f2309bc7e47801c54fb5e"
    end
  end

  on_linux do
    depends_on arch: :x86_64

    on_arm do
      odie "Homebrew on Linux ARM64 is not supported. Use the release installer (install.sh) or npm install -g sakuralang."
    end

    on_intel do
      url "https://github.com/icantcodefyi/sakuralang/releases/download/v1.0.0-beta.2/sakuralang-1.0.0-beta.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5fbdd1492633727a49f7f17c8f3afff0b0f8d6955aaa6459e6d1a9b7086152ff"
    end
  end

  conflicts_with "sakuralang", because: "both install `sakura`"

  def install
    bin.install "sakura"
    doc.install "README.md", "THIRD-PARTY-NOTICES.md"
  end

  test do
    assert_match "sakura #{version} (", shell_output("#{bin}/sakura --version")
    system bin/"sakura", "new", "cli", "demo"
    cd "demo" do
      system bin/"sakura", "check"
      system bin/"sakura", "test"
      system bin/"sakura", "build"
    end
  end
end
