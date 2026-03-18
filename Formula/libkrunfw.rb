class Libkrunfw < Formula
  desc "Dynamic library bundling a Linux kernel in a convenient storage format"
  homepage "https://github.com/containers/libkrunfw"
  version "5.3.0"
  url "https://github.com/containers/libkrunfw/releases/download/v5.3.0/libkrunfw-prebuilt-aarch64.tgz"
  sha256 "6a3d50ae9c14fa2be4b4b8f1027bde5aa4bc524b5685db8e8212b487cab3d198"
  license all_of: ["GPL-2.0-only", "LGPL-2.1-only"]

  bottle do
    root_url "https://raw.githubusercontent.com/slp/homebrew-krun/master/bottles"
    sha256 cellar: :any, arm64_tahoe: "601a7111a4704a5610cd63d0093b37ec999035310da176cba49d4d00339f1a1c"
    sha256 cellar: :any, arm64_sequoia: "28dd39bdb696940d2df95d13bb648317143b35177e6991375e43155f4a9c8fae"
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
