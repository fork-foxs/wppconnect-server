export default {
  caption: {
    path: '$item',
    formatting: (value: any) => {
      return value.caption || '';
    },
  },
  mimetype: 'mimetype',
  size: 'size',
  fileUrl: {
    path: '$item',
    formatting: (value: any) => {
      return value.fileUrl || '';
    },
  },
};
