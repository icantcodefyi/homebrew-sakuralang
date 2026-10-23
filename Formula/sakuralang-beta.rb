# Formula for the tap icantcodefyi/homebrew-sakuralang (design §17.147). The version and
# SHA-256 placeholders are filled from the release's archives by `tools/release/release.py
# assemble`; the filled file is a release asset, reviewed before it goes to the tap as
# `Formula/sakuralang.rb`.
class SakuralangBeta < Formula
  desc "Agent-first programming language: the sakura compiler and toolchain"
  homepage "https://www.sakuralang.com"
  version "1.0.0-beta.6"
  license any_of: ["MIT", "Apache-2.0"]

  # `sakura run` and `sakura test` execute programs on Node; the release is qualified on Node 26.
  depends_on "node"

  on_macos do
    on_arm do
      url "https://github.com/icantcodefyi/sakuralang/releases/download/v1.0.0-beta.6/sakuralang-1.0.0-beta.6-aarch64-apple-darwin.tar.gz"
      sha256 "441cc561f30709b8226699b1ae96a02cb17a56399920b2a1ce854cc7ccdd95d3"
    end
    on_intel do
      url "https://github.com/icantcodefyi/sakuralang/releases/download/v1.0.0-beta.6/sakuralang-1.0.0-beta.6-x86_64-apple-darwin.tar.gz"
      sha256 "a9c2d4d6fdf07cc4c0910640f8d00710d7c47a9a720a644868d6c7a53659b219"
    end
  end

  on_linux do
    depends_on arch: :x86_64

    on_arm do
      odie "Homebrew on Linux ARM64 is not supported. Use the release installer (install.sh) or npm install -g sakuralang."
    end

    on_intel do
      url "https://github.com/icantcodefyi/sakuralang/releases/download/v1.0.0-beta.6/sakuralang-1.0.0-beta.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9b692c5665c50ee0a2d33aadf42146c025c49a8b25a871e00b629796b5b56a4b"
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
