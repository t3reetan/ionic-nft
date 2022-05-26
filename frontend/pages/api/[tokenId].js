export default function handler(req, res) {
  // get the tokenId from the query params
  const tokenId = req.query.tokenId;

  // As all the images are uploaded on github, we can extract the images from github directly.
  // Replace ---complete_images_directory--- with your github repo's directory that stores your NFT images
  // e.g. https://raw.githubusercontent.com/t3reetan/ionic-nft/main/frontend/public/ionic-nft/
  const image_url =
    "https://raw.githubusercontent.com/t3reetan/ionic-nft/main/frontend/public/ionic-nft/";

  // Using the tokenId that's passed from OpenSea, we construct the specific metadata endpoint URL
  // required to fetch information for that specific NFT.
  // To make our collection compatible with Opensea, we need to follow some Metadata standards
  // when sending back the response from the api.
  // More info can be found here: https://docs.opensea.io/docs/metadata-standards
  res.status(200).json({
    name: "Ionic Element #" + tokenId,
    description:
      "A 5x Unique Ionic Elemental NFTs collection. Only for the worthy.",
    image: image_url + tokenId + ".png",
  });
}
