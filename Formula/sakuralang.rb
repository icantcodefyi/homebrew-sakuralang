# Formula for the tap icantcodefyi/homebrew-sakuralang (design §17.147). The version and
# SHA-256 placeholders are filled from the release's archives by `tools/release/release.py
# assemble`; the filled file is a release asset, reviewed before it goes to the tap as
# `Formula/sakuralang.rb`.
class Sakuralang < Formula
  desc "Agent-first programming language: the sakura compiler and toolchain"
  homepage "https://www.sakuralang.com"
  version "0.1.0"
  license any_of: ["MIT", "Apache-2.0"]

  # `sakura run` and `sakura test` execute programs on Node; the release is qualified on Node 26.
  depends_on "node"

  on_macos do
    on_arm do
      url "https://github.com/icantcodefyi/sakuralang/releases/download/v0.1.0/sakuralang-0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "4107aee9d38b3bb4b0ccc738ff995ab2818b80a792590db1a6ccdff6e5ca9802"
    end
    on_intel do
      url "https://github.com/icantcodefyi/sakuralang/releases/download/v0.1.0/sakuralang-0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "ae0f91ee7f1dc85f97b04ca9d94c988d9a31bcde0d8af0cbad8d4ddc6beabf1c"
    end
  end

  on_linux do
    depends_on arch: :x86_64

    on_arm do
      odie "Homebrew on Linux ARM64 is not supported. Use the release installer (install.sh) or npm install -g sakuralang."
    end

    on_intel do
      url "https://github.com/icantcodefyi/sakuralang/releases/download/v0.1.0/sakuralang-0.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e7af7ac6628ada5f4a1d24a3f839ff286828147aab688c018a960fa9fded48ad"
    end
  end

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
