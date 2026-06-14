/*
  NixOS - TidalCycles & Ardour 4-Orbit (8-Channel) Startup Configuration
*/

s.reboot { // Ses sunucusunu yeniden başlatarak temiz bir açılış yapalım
    
    // 1. SES KARTI VE BELLEK AYARLARI
    s.options.numOutputBusChannels = 8; // 4 Orbit x 2 Kanal = 8 Çıkış (Ardour için)
    s.options.numInputBusChannels = 2;  // Standard 2 Giriş
    s.options.memSize = 8192 * 32;      // Dahili ses kartı için bellek havuzunu genişletiyoruz
    
    // 2. SUPERDIRT MOTORUNU BAŞLATMA
    s.waitForBoot {
        ~dirt = SuperDirt(2, s); // Her bir kanalın stereo (2 kanallı) olacağını belirtiyoruz
        
        // Burası Tidal'ın orijinal sample (ses örnekleri) klasörünü yükler
        ~dirt.loadSoundFiles; 
        
        s.sync; // Ayarların senkronize olmasını bekle
        
        // 3. ORBİTLERİ KANALLARA DAĞITMA (SİHİRLİ DÖNGÜ)
        ~dirt.start(57120, 0 ! 4); // 4 adet orbit odası aç ve Tidal portunu dinle

        // Her bir orbit odasının çıkışını 2'şer kanal kaydırarak Pipewire'a fırlat
        ~dirt.orbits.do { |x, i|
            x.toBus(i * 2); 
        };
    };
};
