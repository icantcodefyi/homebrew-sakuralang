# Formula for the tap icantcodefyi/homebrew-sakuralang (design §17.147). The version and
# SHA-256 placeholders are filled from the release's archives by `tools/release/release.py
# assemble`; the filled file is a release asset, reviewed before it goes to the tap as
# `Formula/sakuralang.rb`.
class SakuralangBeta < Formula
  desc "Agent-first programming language: the sakura compiler and toolchain"
  homepage "https://www.sakuralang.com"
  version "1.0.0-beta.1"
  license any_of: ["MIT", "Apache-2.0"]

  # `sakura run` and `sakura test` execute programs on Node; the release is qualified on Node 26.
  depends_on "node"

  on_macos do
    on_arm do
      url "https://github.com/icantcodefyi/sakuralang/releases/download/v1.0.0-beta.1/sakuralang-1.0.0-beta.1-aarch64-apple-darwin.tar.gz"
      sha256 "28d786b1f3eb5e9239be28a89ee5ec48ae6fe5db4876fd1607665522cb5b9401"
    end
    on_intel do
      url "https://github.com/icantcodefyi/sakuralang/releases/download/v1.0.0-beta.1/sakuralang-1.0.0-beta.1-x86_64-apple-darwin.tar.gz"
      sha256 "1f3648cd826bf83ac6bbbab9cf47c07f4cf4dbdf7a6190d0f8cdd65ee2516a00"
    end
  end

  on_linux do
    depends_on arch: :x86_64

    on_arm do
      odie "Homebrew on Linux ARM64 is not supported. Use the release installer (install.sh) or npm install -g sakuralang."
    end

    on_intel do
      url "https://github.com/icantcodefyi/sakuralang/releases/download/v1.0.0-beta.1/sakuralang-1.0.0-beta.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "971379a16b464b5872ca874fb5692a622c6d5b156b77b0190730eaad22ad3f5f"
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
