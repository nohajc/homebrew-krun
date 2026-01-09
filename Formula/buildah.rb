class Buildah < Formula
  desc "Tool that facilitates building OCI images"
  homepage "https://buildah.io"
  url "https://github.com/containers/buildah/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "4e406a0cc6a90066cd471deea252fe8862dbd7fa9cb72b274617673d6159a32b"
  license "Apache-2.0"

  bottle do
    root_url "https://raw.githubusercontent.com/slp/homebrew-krun/master/bottles"
    sha256 cellar: :any, arm64_tahoe: "a147965cf518957f04c69409ba48b32abadde84e4ca3fa0aa14af733a6f4d750"
    sha256 cellar: :any, arm64_sequoia: "b044294d44ad99067eb5807fabab5c1f85d8c6f55219a410315893c48fb45ba5"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "gpgme"

  def install
    system "make", "bin/buildah", "docs"
    bin.install "bin/buildah" => "buildah"
    mkdir_p etc/"containers"
    etc.install "docs/samples/registries.conf" => "containers/registries.conf"
    etc.install "tests/policy.json" => "containers/policy.json"
    man1.install Dir["docs/*.1"]
  end

  test do
    assert_match "buildah version", shell_output("#{bin}/buildah -v")
  end
end
