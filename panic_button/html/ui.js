window.addEventListener("message", (e) => {
  const data = e.data;
  if (!data || data.type !== "panic_sound") return;

  const audio = new Audio(data.file);
  audio.volume = typeof data.volume === "number" ? data.volume : 0.75;
  audio.play().catch(() => {});
});
