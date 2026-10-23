# Formula for the tap icantcodefyi/homebrew-sakuralang (design §17.147). The version and
# SHA-256 placeholders are filled from the release's archives by `tools/release/release.py
# assemble`; the filled file is a release asset, reviewed before it goes to the tap as
# `Formula/sakuralang.rb`.
class Sakuralang < Formula
  desc "Agent-first programming language: the sakura compiler and toolchain"
  homepage "https://www.sakuralang.com"
  version "1.0.0"
  license any_of: ["MIT", "Apache-2.0"]

  # `sakura run` and `sakura test` execute programs on Node; the release is qualified on Node 26.
  depends_on "node"

  on_macos do
    on_arm do
      url "https://github.com/icantcodefyi/sakuralang/releases/download/v1.0.0/sakuralang-1.0.0-aarch64-apple-darwin.tar.gz"
      sha256 "8e3560c4ff610dd8dc31157be14d16d2d80c1e6beea127a0bf5a6c1c753f411a"
    end
    on_intel do
      url "https://github.com/icantcodefyi/sakuralang/releases/download/v1.0.0/sakuralang-1.0.0-x86_64-apple-darwin.tar.gz"
      sha256 "a1ddcc13897daefcc476fe91dfd5a37a5e98bb615a9deef0e0c73d7db74e833b"
    end
  end

  on_linux do
    depends_on arch: :x86_64

    on_arm do
      odie "Homebrew on Linux ARM64 is not supported. Use the release installer (install.sh) or npm install -g sakuralang."
    end

    on_intel do
      url "https://github.com/icantcodefyi/sakuralang/releases/download/v1.0.0/sakuralang-1.0.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5ae5febd9454bc65a17b0044f66ca8176006c6fa1e26c6f880fa48eb8e72e359"
    end
  end

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
