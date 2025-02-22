/*
  Warnings:

  - The values [CONFIRMED,DELIVERED,CANCELLED] on the enum `OrderStatus` will be removed. If these variants are still used in the database, this will fail.
  - You are about to drop the column `MenuCategoryId` on the `Product` table. All the data in the column will be lost.
  - Added the required column `menuCategoryId` to the `Product` table without a default value. This is not possible if the table is not empty.

*/
-- AlterEnum
BEGIN;
CREATE TYPE "OrderStatus_new" AS ENUM ('PENDING', 'IN_PREPARATION', 'FINISHED');
ALTER TABLE "Order" ALTER COLUMN "status" TYPE "OrderStatus_new" USING ("status"::text::"OrderStatus_new");
ALTER TYPE "OrderStatus" RENAME TO "OrderStatus_old";
ALTER TYPE "OrderStatus_new" RENAME TO "OrderStatus";
DROP TYPE "OrderStatus_old";
COMMIT;

-- DropForeignKey
ALTER TABLE "Product" DROP CONSTRAINT "Product_MenuCategoryId_fkey";

-- AlterTable
ALTER TABLE "Product" DROP COLUMN "MenuCategoryId",
ADD COLUMN     "menuCategoryId" TEXT NOT NULL;

-- AddForeignKey
ALTER TABLE "Product" ADD CONSTRAINT "Product_menuCategoryId_fkey" FOREIGN KEY ("menuCategoryId") REFERENCES "MenuCategory"("id") ON DELETE CASCADE ON UPDATE CASCADE;
