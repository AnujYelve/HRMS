import React, { useState, useEffect } from "react";
import { FiBell } from "react-icons/fi";
import api from "../api/axios";
import useAuthStore from "../stores/authstore";

export default function NotificationDropdown() {
  const [open, setOpen] = useState(false);
  const [notes, setNotes] = useState([]);

  const user = useAuthStore((s) => s.user);

  useEffect(() => {
    const loadNotes = async () => {
      try {
        const r = await api.get("/notifications");
        let all = r.data.notifications || [];

        // ---------------------------
        // 1️⃣ Remove duplicates of Everyone (ADMIN only)
        // ---------------------------
        const everyoneSeen = new Set();
        const noDuplicateEveryone = all.filter((n) => {
          if (n.to === "Everyone") {
            if (everyoneSeen.has(n.title)) return false;
            everyoneSeen.add(n.title);
          }
          return true;
        });

        // ---------------------------
        // 2️⃣ ADMIN sees ALL (cleaned list)
        // ---------------------------
        if (user.role === "ADMIN") {
          setNotes(noDuplicateEveryone);
          return;
        }

        // ---------------------------
        // 3️⃣ EMPLOYEE sees:
        //     - notifications sent to them
        //     - or sent to Everyone
        // ---------------------------
        const filtered = noDuplicateEveryone.filter(
          (n) => n.to === "Everyone" || n.to === user.id
        );

        setNotes(filtered);
      } catch (err) {
        console.log("Failed to load notifications");
      }
    };

    loadNotes();
  }, [user.id, user.role]);

  return (
    <div className="relative">
      <button
        onClick={() => setOpen(!open)}
        className="p-2 rounded-lg bg-gray-100 dark:bg-gray-700"
      >
        <FiBell />
      </button>

      {open && (
        <div className="absolute right-0 mt-2 w-80 bg-white dark:bg-gray-800 rounded-xl shadow-lg border p-3 z-50">
          <h4 className="font-semibold mb-2">Notifications</h4>

          <div className="max-h-56 overflow-auto space-y-3">
            {notes.length === 0 ? (
              <p className="text-sm text-gray-500">No notifications</p>
            ) : (
              notes.map((n) => (
                <div
                  key={n.id}
                  className="p-2 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-700"
                >
                  <div className="text-sm font-bold">{n.title}</div>
                  <div className="text-xs text-gray-400">{n.body}</div>

                  {/* ⭐ ADMIN VIEW → Show receiver */}
                  {user.role === "ADMIN" && (
                    <div className="text-[11px] text-blue-500 mt-1">
                      To: {n.to === "Everyone" ? "Everyone" : n.toName}
                    </div>
                  )}

                  {/* ⭐ EMPLOYEE VIEW → Show sender */}
                  {user.role !== "ADMIN" && (
                    <div className="text-[11px] text-green-500 mt-1">
                      From: {n.fromName || "Admin"}
                    </div>
                  )}
                </div>
              ))
            )}
          </div>
        </div>
      )}
    </div>
  );
}
