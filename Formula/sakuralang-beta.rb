# Formula for the tap icantcodefyi/homebrew-sakuralang (design §17.147). The version and
# SHA-256 placeholders are filled from the release's archives by `tools/release/release.py
# assemble`; the filled file is a release asset, reviewed before it goes to the tap as
# `Formula/sakuralang.rb`.
class SakuralangBeta < Formula
  desc "Agent-first programming language: the sakura compiler and toolchain"
  homepage "https://www.sakuralang.com"
  version "1.0.0-beta.4"
  license any_of: ["MIT", "Apache-2.0"]

  # `sakura run` and `sakura test` execute programs on Node; the release is qualified on Node 26.
  depends_on "node"

  on_macos do
    on_arm do
      url "https://github.com/icantcodefyi/sakuralang/releases/download/v1.0.0-beta.4/sakuralang-1.0.0-beta.4-aarch64-apple-darwin.tar.gz"
      sha256 "1ff98c5a70da66a91ff567dfc869610de925472e700a7fe5a0b4f72ae64fcb3c"
    end
    on_intel do
      url "https://github.com/icantcodefyi/sakuralang/releases/download/v1.0.0-beta.4/sakuralang-1.0.0-beta.4-x86_64-apple-darwin.tar.gz"
      sha256 "b6a74f57f9308e73af469f9f4ae4a0fc0c508a43f31f632f3a036c032c6d483a"
    end
  end

  on_linux do
    depends_on arch: :x86_64

    on_arm do
      odie "Homebrew on Linux ARM64 is not supported. Use the release installer (install.sh) or npm install -g sakuralang."
    end

    on_intel do
      url "https://github.com/icantcodefyi/sakuralang/releases/download/v1.0.0-beta.4/sakuralang-1.0.0-beta.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0443c7251c8e674a828ce05da2465e5ccbac322e3870106b8172ed23c805ad78"
    end
  end

  conflicts_with "sakuralang", because: "both install `sakura`"

  def install
    bin.install "sakura"
    # The `--target native` driver (experimental) on the targets that ship it, beside `bin/`.
    native = Dir["lib/sakura/native/*"]
    (lib/"sakura/native").install native unless native.empty?
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
