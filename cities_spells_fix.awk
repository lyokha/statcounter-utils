function suspicious_repl(t, a, r, c, nr, nc)
{
    if (warn_suspicious) {
        if (suspicious_count++ == 0)
            printf "Suspicious locations replaced:\n%s\n",
                delim > "/dev/stderr";
        printf "%s | %+15s | %s (%s)  ->  %s (%s)\n",
                t,       a,  $c, $r,      nc, nr  > "/dev/stderr"
    }
    $r = nr;
    $c = nc
}

BEGIN   { FS="\",\""; OFS = FS;
          # warn_suspicious is expected to be passed via command line
          warn_suspicious = warn_suspicious ~ /^y(es)?$/;
          suspicious_count = 0;
          delim = "--------"
        }

NR < 2  { print; next }

        { switch ($9) {
              case "Krasnoyarskiy Kray":            # Russian Federation
                  $9 = "Krasnoyarsk";
                  break
          }
          switch ($10) {
              case "Tolyatti":                      # Russian Federation
                  $10 = "Togliatti";
                  break
              case "Togliatti":
                  if ($9 == "Sakha")
                      $9 = "Samara";
                  break
              case "Cheliabinsk":
                  $10 = "Chelyabinsk";
                  break
              case "Rostov-na-donu":
                  $10 = "Rostov-on-don";
                  break
              case "Rostov":
                  if ($9 == "Rostov")
                      $10 = "Rostov-on-don";
                  break
              case "Sverdlovsk":
                  if ($9 == "Sverdlovsk")
                      $10 = "Yekaterinburg";
                  break
              case "Nizhni Tagil":
                  $10 = "Nizhniy Tagil";
                  break
              case "Tagil":
                  if ($9 == "Tatarstan") {
                      $9 = "Sverdlovsk";
                      $10 = "Nizhniy Tagil"
                  }
                  break
              case "Nizhnii Novgorod":
                  $10 = "Nizhniy Novgorod";
                  break
              case "Velikiy Novgorod":
                  if ($9 == "Novosibirsk")
                      $9 = "Novgorod";
                  break
              case "Orenburg":
                  if ($9 == "Khabarovsk")
                      $9 = "Orenburg";
                  break
              case "Komsomolsk":
                  if ($9 == "Khabarovsk")
                      $10 = "Komsomolsk-na-amure";
                  break
              case "Yugra":
                  if ($9 == "Vologda" && $12 ~ "Yugra State University") {
                      $9 = "Khanty-Mansiy";
                      $10 = "Khanty-Mansiysk"
                  }
                  break
              case "Gogolya":
                  if ($12 == "Kurgan state university") {
                      $9 = "Kurgan";
                      $10 = "Kurgan"
                  }
                  break
              case "Ramenskoe":
                  $10 = "Ramenskoye";
                  break
              case "Mytishi":
                  $10 = "Mytishchi";
                  break
              case "Khimki":
                  if ($9 == "Moscow City")
                      $9 = "Moskva";
                  break
              case "Zhukovskiy":
                  if ($9 == "Moscow City")
                      $9 = "Moskva";
                  break
              case "Saint-petersburg":
              case "Sankt-peterburg":
              case "Leningrad":
                  $10 = "Saint Petersburg";
                  break
              case "Belebei":
                  $10 = "Belebey";
                  break
              case "Staryy Oskol":
                  $10 = "Stary Oskol";
                  break
              case "Yaroslavl":
                  if ($9 == "Kirov")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Yaroslavl'", $10);
                  break
              case "Belgorod":
                  if ($9 == "Bryansk")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Belgorod", $10);
                  break
              case "Stavropol":
                  if ($9 == "Samara")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Stavropol'", $10);
                  break
              case "Samara":
                  if ($9 == "Orel")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Samara", $10);
                  break
              case "Kirov":
                  if ($9 == "Stavropol'")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Kirov", $10);
                  break
              case "Kazan":
                  if ($9 == "Kirov")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Tatarstan", $10);
                  break
              case "Kharkiv":                       # Ukraine
                  $10 = "Kharkov";
                  break
              case "Lvov":
              case "Lwów":
                  $10 = "Lviv";
                  break
              case "Dnipropetrovsk":
              case "Dniepropetrovsk":
                  $10 = "Dnepropetrovsk";
                  break
              case "Luhansk":
                  $10 = "Lugansk";
                  break
              case "Lugansk":
                  if ($9 == "Zaporiz'ka Oblast'")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Luhans'ka Oblast'", $10);
                  break
              case "Vinnytsya":
                  $10 = "Vinnitsa";
                  break
              case "Cherkasy":
                  $10 = "Cherkassy";
                  break
              case "Chernihiv":
                  $10 = "Chernigov";
                  break
              case "Kremenchuk":
                  $10 = "Kremenchug";
                  break
              case "Zhytomyr":
                  $10 = "Zhitomir";
                  break
              case "Chortkiv":
                  $10 = "Chortkov";
                  break
              case "Kyiv":
                  $10 = "Kiev";
                  break
              case "Zaporozhye":
                  $10 = "Zaporizhzhya";
                  break
              case "Sevastopol":
                  if ($9 == "Kaluga") {
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Sevastopol'", $10);
                      $8 = "Ukraine"
                  }
                  break
              case "Mogilev":                       # Belarus
                  $10 = "Mogilëv";
                  break
              case "Grodno":
                  if ($9 == "Minskaya Voblasts'")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Hrodzyenskaya Voblasts'", $10);
                  break
              case "Gomel":
                  if ($9 == "Vitsyebskaya Voblasts'")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Homyel'skaya Voblasts'", $10);
                  break
              case "Erevan":                        # Armenia
                  $10 = "Yerevan";
                  break
              case "Qostanay":                      # Kazakhstan
                  $10 = "Kostanay";
                  break
              case "Aktobe":
                  if ($9 == "Almaty")
                      suspicious_repl(substr($1, 2), $2, 9, 10,
                                      "Almaty City", "Almaty");
                  break
              case "Frankfurt":                     # Germany
                  if ($9 == "Hessen")
                      $10 = "Frankfurt Am Main";
                  break
              case "Muenster":
                  $10 = "Münster";
                  break
              case "Geneve":                        # Switzerland
                  if ($9 == "Geneve")
                      $10 = "Geneva";
                  break
          }
          print
        }

END     { if (suspicious_count > 0)
              printf "%s (%d repls)\n", delim, suspicious_count > "/dev/stderr"
        }

# Potentially ambiguos locations (you may want to check them with whois):
#   Donetsk  (Rostov) -> Donetsk  (Donets'ka Oblast')

# Apparently wrong locations:
#   Dmitriy  (Odes'ka Oblast')
#   Oleg  (Odes'ka Oblast')

