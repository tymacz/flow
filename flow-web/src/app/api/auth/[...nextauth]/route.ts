import { handlers } from "@/server/auth";

export const authOptions = {
  trustHost:true,};
const handler = NextAuth(authOptions);

export { handler as GET, handler as POST };
