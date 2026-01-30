importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js");

firebase.initializeApp({
    apiKey: "AIzaSyDRaelu40fOd-DLQXDyOpcKjjjINEXEn_I",
     authDomain: "madebymaa-633ee.firebaseapp.com",
     projectId: "madebymaa-633ee",
     storageBucket: "madebymaa-633ee.appspot.com",
     messagingSenderId: "367368154263",
     appId: "1:367368154263:web:69f4ceb338bf5167658dd2",
     measurementId: "G-7L0QF7CE8Q"
});

const messaging = firebase.messaging();

messaging.setBackgroundMessageHandler(function (payload) {
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
        .then(() => {
            const title = payload.notification.title;
            const options = {
                body: payload.notification.score
              };
            return registration.showNotification(title, options);
        });
    return promiseChain;
});
self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
});