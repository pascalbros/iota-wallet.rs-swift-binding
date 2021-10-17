Pod::Spec.new do |s|
  s.name             = 'IotaWallet'
  s.version          = '0.1.0'
  s.summary          = 'Iota Wallet for iOS'
  s.description      = <<-DESC
Iota Wallet for iOS
                       DESC

  s.homepage         = 'https://github.com/pascalbros/iota-wallet.rs-swift-binding'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Pasquale Ambrosini' => 'pasquale.ambrosini@gmail.com' }
  s.source           = { :git => 'https://github.com/pascalbros/iota-wallet.rs-swift-binding.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'
  s.osx.deployment_target = '10.10'

  s.source_files = 'Sources/**/*.{swift}'

  s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lc++' }

  s.weak_frameworks = 'IOTAWalletInternal'
  s.script_phase = {  
    :name => 'Fix Umbrella',    
    :script => '
file="${SRCROOT}/Target Support Files/IotaWallet/IotaWallet-umbrella.h"
ls "${SRCROOT}/Target Support Files/IotaWallet/"
if [ ! -f $file ]; then
    exit 0
fi
text=\'
#ifdef __OBJC__
#import <Foundation/Foundation.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

typedef void (*Callback)(const char *response);

#ifdef __cplusplus
extern "C" {
#endif

void iota_initialize(Callback callback, const char *actor_id, const char *storage_path);
void iota_destroy(const char *actor_id);
void iota_send_message(const char *message);
void iota_listen(const char *actor_id, const char *id, const char *event_name);

#ifdef __cplusplus
}
#endif


FOUNDATION_EXPORT double IotaWalletVersionNumber;
FOUNDATION_EXPORT const unsigned char IotaWalletVersionString[];
\'
echo "$text" > "${SRCROOT}/Target Support Files/IotaWallet/IotaWallet-umbrella.h"
',    
    :execution_position => :before_compile  
  }

  #s.dependency 'IotaWalletInternal'
end
