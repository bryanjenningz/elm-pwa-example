const mockPicture =
  "http://s3.amazonaws.com/37assets/svn/765-default-avatar.png";

const mockPictures = Array.from({ length: 9 }, () => mockPicture);

const mockComments = Array.from({ length: 3 }, (_, i) => {
  if (i % 2 === 0) {
    return {
      userId: "id_example123",
      name: "example name",
      text: "test reply 123!!!"
    };
  } else {
    return {
      userId: "id_abe123",
      name: "abe name",
      text: "this is just a test reply, I hope this reply is not too long"
    };
  }
});

const mockMoment = {
  userId: "id_example123",
  pictures: mockPictures,
  text: Array.from({ length: 10 }, () => "test moment ").join(""),
  likes: 2,
  comments: mockComments
};

const mockMoments = Array.from({ length: 10 }, () => mockMoment);

const mockUser = {
  id: "id_example123",
  name: "example name",
  email: "example@example.com",
  age: 99,
  isMan: true,
  lastLogin: 20,
  location: "Pleasantville, Pleasant Country",
  localTime: "7:38 PM",
  learning: {
    shortName: "EN",
    name: "English",
    level: 2
  },
  native: {
    shortName: "CN",
    name: "中文",
    level: 5
  },
  corrections: 22,
  savedWords: 34,
  audioLookups: 5,
  translationLookups: 2,
  bookmarks: 0,
  intro: Array.from({ length: 10 }, () => "this is a test intro").join(", "),
  interests: ["Music", "Soccer", "Movies"],
  picture: mockPicture,
  moments: mockMoments
};

const mockMessage = {
  user: mockUser,
  time: 10000000,
  text: "Hello",
  read: true
};

const mockTalks = Array.from({ length: 10 }, () => ({
  user: mockUser,
  messages: Array.from({ length: 10 }, () => mockMessage)
}));

module.exports = {
  mockPicture,
  mockPictures,
  mockComments,
  mockMoment,
  mockMoments,
  mockUser,
  mockMessage,
  mockTalks
};
