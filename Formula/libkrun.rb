class Libkrun < Formula
  desc "Dynamic library providing KVM-based process isolation capabilities"
  homepage "https://github.com/containers/libkrun"
  version "1.17.4"
  url "https://github.com/containers/libkrun/archive/refs/tags/v1.17.4.tar.gz"
  sha256 "2708a3c207c5493ee02de1781836c2511e54eb280633fcc7058fee983a6c2fe3"
  license "Apache-2.0"

  bottle do
    root_url "https://raw.githubusercontent.com/slp/homebrew-krun/master/bottles"
    sha256 cellar: :any, arm64_tahoe: "c36a9013a414616270cadf9a31767a91dde967d4a76134304e2ab75d76af1518"
    sha256 cellar: :any, arm64_sequoia: "8d42c08ba7d94b8cb15d1cb64af7025b39df3e3cda3d306904596d4589fc495c"
  end

  depends_on "rust" => :build
  # Upstream only supports Hypervisor.framework on arm64
  depends_on arch: :arm64
  depends_on "dtc"
  depends_on "lld"
  depends_on "libkrunfw"
  depends_on "virglrenderer"
  depends_on "xz"

  def install
    system "make", "BLK=1", "NET=1", "GPU=1", "TIMESYNC=1"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libkrun.h>
      int main()
      {
         int c = krun_create_ctx();
         return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lkrun", "-o", "test"
    system "./test"
  end
end
