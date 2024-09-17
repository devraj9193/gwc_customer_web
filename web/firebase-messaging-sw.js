importScripts('https://www.gstatic.com/firebasejs/8.4.1/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.4.1/firebase-messaging.js');


  const firebaseConfig = {
      apiKey: "AIzaSyBgy_4Mvwz8liIXN4Oyj-fgptglL1hjBYI",
      appId: "1:40324540760:web:88eb0644c3fabf708a9d2d",
      messagingSenderId: "40324540760",
      projectId: "gwc-web-2a25b",
    };
  firebase.initializeApp(firebaseConfig);
  const messaging = firebase.messaging();


  messaging.onBackgroundMessage(function(payload) {
    console.log('Received background message ', payload);

    const notificationTitle = payload.notification.title;
    const notificationOptions = {
      body: payload.notification.body,
    };

    self.registration.showNotification(notificationTitle,
      notificationOptions);
  });