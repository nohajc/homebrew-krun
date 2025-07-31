class Libkrunfw < Formula
  desc "Dynamic library bundling a Linux kernel in a convenient storage format"
  homepage "https://github.com/containers/libkrunfw"
  version "4.10.0"
  url "https://github.com/containers/libkrunfw/releases/download/v4.10.0/libkrunfw-4.10.0-prebuilt-aarch64.tar.gz"
  sha256 "6732e0424ce90fa246a4a75bb5f3357a883546dbca095fee07a7d587e82d94b0"
  license all_of: ["GPL-2.0-only", "LGPL-2.1-only"]

  bottle do
    root_url "https://raw.githubusercontent.com/slp/homebrew-krun/master/bottles"
    sha256 cellar: :any, arm64_sequoia: "2ec70626ad2cb60718e74ef6dcc9f4cc4932481b8bda4a84b8dbc37b2dd08d49"
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
