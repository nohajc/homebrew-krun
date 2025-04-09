class Libkrunfw < Formula
  desc "Dynamic library bundling a Linux kernel in a convenient storage format"
  homepage "https://github.com/containers/libkrunfw"
  version "4.9.0"
  url "https://github.com/containers/libkrunfw/releases/download/v4.9.0/libkrunfw-4.9.0-prebuilt-aarch64.tar.gz"
  sha256 "42f59b7ea3a74240fc326fafa71b8687347ba68397762902ca2fed4d2761315c"
  license all_of: ["GPL-2.0-only", "LGPL-2.1-only"]

  bottle do
    root_url "https://raw.githubusercontent.com/slp/homebrew-krun/master/bottles"
    sha256 cellar: :any, arm64_sequoia: "6b1f07978422e35c42d9df873e81f22a78cad63e5bb679f8b53463f54244ed35"
  end

  # libkrun, our only consumer, only supports Hypervisor.framework on arm64
  depends_on arch: :arm64

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      int krunfw_get_version();
      int main()
      {
         int v = krunfw_get_version();
         return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lkrunfw", "-o", "test"
    system "./test"
  end
end
