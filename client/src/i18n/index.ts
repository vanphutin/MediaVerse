import i18n from "i18next";
import { initReactI18next } from "react-i18next";
import LanguageDetector from "i18next-browser-languagedetector";

import common_en from "./locales/en/common.json";
import auth_en from "./locales/en/auth.json";
// import navbar_en from "./locales/en/navbar.json";
// import home_en from "./locales/en/home.json";
// import player_en from "./locales/en/player.json";

import common_vi from "./locales/vi/common.json";
import auth_vi from "./locales/vi/auth.json";
// import navbar_vi from "./locales/vi/navbar.json";
// import home_vi from "./locales/vi/home.json";
// import player_vi from "./locales/vi/player.json";

i18n
  .use(LanguageDetector)
  .use(initReactI18next)
  .init({
    ns: ["common", "auth", "navbar", "home", "player"],
    defaultNS: "common",

    resources: {
      en: {
        common: common_en,
        auth: auth_en,
        // navbar: navbar_en,
        // home: home_en,
        // player: player_en,
      },
      vi: {
        common: common_vi,
        auth: auth_vi,
        // navbar: navbar_vi,
        // home: home_vi,
        // player: player_vi,
      },
    },

    fallbackLng: "en",
    interpolation: {
      escapeValue: false,
    },

    detection: {
      order: ["localStorage", "navigator"],
      caches: ["localStorage"],
    },
  });

export default i18n;
