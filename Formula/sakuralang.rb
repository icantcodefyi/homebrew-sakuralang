# Formula for the tap icantcodefyi/homebrew-sakuralang (design §17.147). The version and
# SHA-256 placeholders are filled from the release's archives by `tools/release/release.py
# assemble`; the filled file is a release asset, reviewed before it goes to the tap as
# `Formula/sakuralang.rb`.
class Sakuralang < Formula
  desc "Agent-first programming language: the sakura compiler and toolchain"
  homepage "https://www.sakuralang.com"
  version "0.1.0-alpha.1"
  license any_of: ["MIT", "Apache-2.0"]

  # `sakura run` and `sakura test` execute programs on Node; the release is qualified on Node 26.
  depends_on "node"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/icantcodefyi/sakuralang/releases/download/v0.1.0-alpha.1/sakuralang-0.1.0-alpha.1-aarch64-apple-darwin.tar.gz"
      sha256 "2760a8250fe3c903653111f3dd9e514e8163c4214349aef503577e195e94e85c"
    end
  end

  on_linux do
    depends_on arch: :x86_64

    on_intel do
      url "https://github.com/icantcodefyi/sakuralang/releases/download/v0.1.0-alpha.1/sakuralang-0.1.0-alpha.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9b25b383645d30c605acfddb12e96b2faa96c6b130ab8e962981be08559cf1a9"
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
