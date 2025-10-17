import { useState, useEffect } from "react";
import { motion, AnimatePresence } from "framer-motion";



export default function App() {
    const [quote, setQuote] = useState("");
    const [language, setLanguage] = useState<"fr" | "en" | null>(null);
    const [intervalId, setIntervalId] = useState<ReturnType<typeof setInterval> | null>(null);

    const API_URL = import.meta.env.VITE_API_URL;

    async function fetchQuote(lang: "fr" | "en") {
        try {
            const res = await fetch(`${API_URL}/affirmation/${lang}`);
            const data = await res.json();
            setQuote(data.affirmation || "⚠️ Erreur lors du chargement...");
        } catch (e) {
            setQuote("❌ Impossible de récupérer la citation.");
        }
    }

    useEffect(() => {
        if (language) {
            fetchQuote(language);
            const id = setInterval(() => fetchQuote(language), 5000);
            setIntervalId(id);
            return () => clearInterval(id);
        }
    }, [language]);

    return (
        <div>
            <h1>💡 Affirmations💡</h1>

            {!language ? (
                <div className="language-choice">
                    <p>Choisis ta langue :</p>
                    <div className="language-buttons">
                        <button className="primary" onClick={() => setLanguage("fr")}>
                            🇫🇷 Français
                        </button>
                        <button className="primary" onClick={() => setLanguage("en")}>
                            🇬🇧 English
                        </button>
                    </div>
                </div>
            ) : (
                <>
                    <AnimatePresence mode="wait">
                        <motion.p
                            key={quote}
                            className="quote"
                            initial={{ opacity: 0, y: 10 }}
                            animate={{ opacity: 1, y: 0 }}
                            exit={{ opacity: 0, y: -10 }}
                            transition={{ duration: 0.5 }}
                        >
                            {quote}
                        </motion.p>
                    </AnimatePresence>

                    <button
                        className="secondary"
                        onClick={() => {
                            setLanguage(null);
                            setQuote("");
                            if (intervalId) clearInterval(intervalId);
                        }}
                    >
                        🔄 Changer de langue
                    </button>
                </>
            )}
        </div>
    );
}
