class Gvproxy < Formula
  desc "A new network stack based on gVisor"
  homepage "https://github.com/containers/gvisor-tap-vsock"
  url "https://github.com/containers/gvisor-tap-vsock/archive/refs/tags/v0.8.8.tar.gz"
  sha256 "4f7c4885225d71b21f6b547b94d92fc6da4a4fef9d382fdd19c8ea67f67be839"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "e168fbcc20349cfdcd524487cbb81ce223a72c44bde4542bb761f74f1b8d5cc3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70edf64228db59e9b57953ab3b2a12c910f0ffd41ec1583ce9838ec41a45b865"
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "bin/gvproxy" => "gvproxy"
  end

  test do
    assert_match "gvproxy version", shell_output("#{bin}/gvproxy -version")
  end
end
