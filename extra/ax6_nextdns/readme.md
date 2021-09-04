# ax6_dot-stubby

Удалось поднять DoT (DNS-Over-TLS) на stubby.

Оформил все в скрипт автоинсталла.
За базу взял Xiaomi AIoT Router AX3600 WiFi 6 – обсуждение (Пост alllexx88 #101683165) за что спасибо alllexx88

Для установки одной командой необходимы:
- SSH доступ
- Установленная прошивка с /opt директорией в корне

Установка:
curl -k https://raw.githubusercontent.com/aalsmile/mi_ax3600/main/dot_adblock_autoinstall.sh | sh -


На выходе получите:
- Блокировку рекламы и потенциально опасных сайтов на уровне роутера (десктоп + мобильная реклама, малварь и т.д.) + возможность дополнения и исключения через черный/белый списки (/opt/etc/adblock/black.list и /opt/etc/adblock/white.list) своих доменов.
- DNS over TLS на уровне роутера (Быстрее и безопаснее запросы к DNS для резолва доменных имен).
- Установленный пакетный менеджер и репо Entware (возможность ставить дополнительные пакеты, доступные к OpenWRT, через /opt/bin/opkg install [пакет] ).

PS: Теперь мой переезд с Mi Router 3G на данный роутер можно считать практически полноценным.


Дополнительно можете запретить все остальные DNS для клиентов подключенных к вашему wifi, даже если они указаны явно на подключенном устройстве.
Сделать это можно закрыв 53 порт из LAN в WAN по tcp/udp
# 
1) Правим конфиг firewall по пути /etc/config/firewall
В конец файла добавляем
config rule                                                
        option name 'Disallow-other-DNS'    
        option src 'lan'                    
        option dest 'wan'                      
        option proto 'tcp udp'                             
        option dest_port '53'                              
        option target 'REJECT' 


2) Делаем релоад firewall
fw3 reload