const resolvers = {
  DesignVersion: {
    author: () => ({
      avatarUrl:
        'https://www.gravatar.com/avatar/e64c7d89f26bd1972efa854d13d7dd61?s=80&d=identicon',
      name: 'Administrator', // eslint-disable-line @gitlab/i18n/no-non-i18n-strings
      __typename: 'User', // eslint-disable-line @gitlab/i18n/no-non-i18n-strings
    }),
    createdAt: () => '2019-11-13T16:08:11Z',
  },
};

export default resolvers;
