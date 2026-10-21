# Formula for the tap icantcodefyi/homebrew-sakuralang (design §17.147). The version and
# SHA-256 placeholders are filled from the release's archives by `tools/release/release.py
# assemble`; the filled file is a release asset, reviewed before it goes to the tap as
# `Formula/sakuralang.rb`.
class SakuralangBeta < Formula
  desc "Agent-first programming language: the sakura compiler and toolchain"
  homepage "https://www.sakuralang.com"
  version "1.0.0-beta.3"
  license any_of: ["MIT", "Apache-2.0"]

  # `sakura run` and `sakura test` execute programs on Node; the release is qualified on Node 26.
  depends_on "node"

  on_macos do
    on_arm do
      url "https://github.com/icantcodefyi/sakuralang/releases/download/v1.0.0-beta.3/sakuralang-1.0.0-beta.3-aarch64-apple-darwin.tar.gz"
      sha256 "4b15bde2296a31127236e782ab7f982a8f1c7fc9645586ba819a9e9295085fee"
    end
    on_intel do
      url "https://github.com/icantcodefyi/sakuralang/releases/download/v1.0.0-beta.3/sakuralang-1.0.0-beta.3-x86_64-apple-darwin.tar.gz"
      sha256 "d618f652ae0b2cd8d0bbc845e1371f61b27a76d3d394844453ad1f7df1b0b1f4"
    end
  end

  on_linux do
    depends_on arch: :x86_64

    on_arm do
      odie "Homebrew on Linux ARM64 is not supported. Use the release installer (install.sh) or npm install -g sakuralang."
    end

    on_intel do
      url "https://github.com/icantcodefyi/sakuralang/releases/download/v1.0.0-beta.3/sakuralang-1.0.0-beta.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "35c3f6c41a0219927504febb27922cd244e9c8ea41fa0bba7050abb978acb998"
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
